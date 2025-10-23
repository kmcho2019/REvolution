module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Control signals
    reg [4:0] count;
    wire count_en = start && (count < 16);
    wire op_active = (count > 0) && (count < 17);
    
    // Datapath registers
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    reg [31:0] acc_stage;
    reg [15:0] shifted_bin;
    wire [31:0] shifted_bin_ext = {16'b0, shifted_bin};
    
    // Clock gating signals
    wire shift_clk_en = op_active;
    wire shift_clk = shift_clk_en & clk;
    
    // Control logic (counter)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 16) begin
                    count <= 5'd0;
                    done <= 1'b1;
                end else begin
                    count <= count + 5'd1;
                    done <= 1'b0;
                end
            end else begin
                count <= 5'd0;
                done <= 1'b0;
            end
        end
    end

    // Main datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            acc_stage <= 32'b0;
            yout <= 32'b0;
        end else begin
            // Stage 1: Load operands or accumulate
            if (start) begin
                if (count == 0) begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                end else if (count <= 16) begin
                    if (areg[count-1]) begin
                        acc_stage <= acc + shifted_bin_ext;
                    end else begin
                        acc_stage <= acc;
                    end
                end
            end
            
            // Stage 2: Register accumulator output
            if (count == 16) begin
                yout <= acc_stage;
            end
        end
    end

    // Shift register with clock gating
    always @(posedge shift_clk or negedge rst_n) begin
        if (!rst_n) begin
            shifted_bin <= 16'b0;
        end else begin
            if (count == 1) begin
                shifted_bin <= breg;
            end else if (count > 1 && count <= 16) begin
                shifted_bin <= shifted_bin << 1;
            end
        end
    end

endmodule