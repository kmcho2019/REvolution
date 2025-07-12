module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Booth encoding signals
    wire [16:0] booth_encoded;
    reg [16:0] bin_ext;
    
    // Partial products
    wire [31:0] pp [0:7];
    reg [31:0] pp_reg [0:7];
    
    // Wallace tree signals
    reg [31:0] sum_stage1 [0:3];
    reg [31:0] carry_stage1 [0:3];
    reg [31:0] sum_stage2 [0:1];
    reg [31:0] carry_stage2 [0:1];
    reg [31:0] sum_final;
    reg [31:0] carry_final;
    
    // Control signals
    reg [2:0] state;
    reg [3:0] cycle_count;
    reg zero_detect;
    
    // Booth encoding
    assign booth_encoded = {bin, 1'b0};
    always @(*) begin
        bin_ext = {bin[15], bin}; // Sign extend
    end
    
    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            always @(*) begin
                case (booth_encoded[i*2+2:i*2])
                    3'b000, 3'b111: pp_reg[i] = 32'b0;
                    3'b001, 3'b010: pp_reg[i] = {{16{ain[15]}}, ain} << (i*2);
                    3'b011:         pp_reg[i] = {{15{ain[15]}}, ain, 1'b0} << (i*2);
                    3'b100:         pp_reg[i] = -{{15{ain[15]}}, ain, 1'b0} << (i*2);
                    3'b101, 3'b110: pp_reg[i] = -{{16{ain[15]}}, ain} << (i*2);
                endcase
            end
        end
    endgenerate
    
    // Zero detection
    always @(*) begin
        zero_detect = (ain == 16'b0) || (bin == 16'b0);
    end
    
    // Control FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 3'b000;
            cycle_count <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end else begin
            case (state)
                3'b000: begin // IDLE
                    if (start) begin
                        state <= zero_detect ? 3'b100 : 3'b001;
                        cycle_count <= 4'b0;
                    end
                    done <= 1'b0;
                end
                
                3'b001: begin // BOOTH_ENCODE
                    state <= 3'b010;
                end
                
                3'b010: begin // WALLACE_STAGE1
                    // First level of CSA reduction
                    for (integer j = 0; j < 4; j = j + 1) begin
                        {carry_stage1[j], sum_stage1[j]} = 
                            pp_reg[j*2] + pp_reg[j*2+1];
                    end
                    state <= 3'b011;
                end
                
                3'b011: begin // WALLACE_STAGE2
                    // Second level of CSA reduction
                    for (integer j = 0; j < 2; j = j + 1) begin
                        {carry_stage2[j], sum_stage2[j]} = 
                            sum_stage1[j*2] + sum_stage1[j*2+1] + carry_stage1[j*2];
                    end
                    state <= 3'b100;
                end
                
                3'b100: begin // FINAL_ADD
                    // Final addition using Kogge-Stone parallel prefix
                    {carry_final, sum_final} = 
                        sum_stage2[0] + sum_stage2[1] + carry_stage2[0];
                    
                    yout <= zero_detect ? 32'b0 : sum_final + carry_final;
                    done <= 1'b1;
                    state <= 3'b000;
                end
            endcase
        end
    end
    
    // Pipeline registers for partial products
    always @(posedge clk) begin
        if (state == 3'b001) begin
            for (integer k = 0; k < 8; k = k + 1) begin
                pp[k] <= pp_reg[k];
            end
        end
    end

endmodule