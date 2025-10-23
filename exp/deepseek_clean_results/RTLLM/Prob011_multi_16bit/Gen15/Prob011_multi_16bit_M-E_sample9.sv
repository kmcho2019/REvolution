module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Booth encoding states
    localparam IDLE = 0;
    localparam BOOTH = 1;
    localparam ACCUM = 2;
    localparam FINISH = 3;

    reg [1:0] state;
    reg [2:0] count;
    reg [15:0] multiplicand;
    reg [31:0] partial_sum;
    reg [31:0] accumulator;
    reg zero_flag;
    
    // Booth encoder signals
    wire [1:0] booth_bits;
    wire [31:0] booth_mux_out;
    wire [31:0] shifted_pp;
    
    // Booth encoder
    assign booth_bits = (count == 0) ? {bin[0], 1'b0} : bin[count*2-:2];
    
    // Booth multiplexer
    assign booth_mux_out = 
        (booth_bits == 2'b01) ? {16'b0, multiplicand} :
        (booth_bits == 2'b10) ? ~{16'b0, multiplicand} + 1 :
        (booth_bits == 2'b11) ? ~{16'b0, multiplicand} << 1 + 1 :
        {32{1'b0}};
    
    // Partial product shifter
    assign shifted_pp = booth_mux_out << (count*2);
    
    // Zero detection
    always @(*) begin
        zero_flag = (bin == 16'b0);
    end

    // Main state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 0;
            multiplicand <= 0;
            partial_sum <= 0;
            accumulator <= 0;
            yout <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        multiplicand <= ain;
                        accumulator <= 0;
                        count <= 0;
                        state <= (zero_flag) ? FINISH : BOOTH;
                    end
                end
                
                BOOTH: begin
                    partial_sum <= shifted_pp;
                    state <= ACCUM;
                end
                
                ACCUM: begin
                    accumulator <= accumulator + partial_sum;
                    if (count == 3'd7) begin
                        state <= FINISH;
                    end else begin
                        count <= count + 1;
                        state <= BOOTH;
                    end
                end
                
                FINISH: begin
                    yout <= accumulator;
                    done <= 1;
                    if (!start) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule