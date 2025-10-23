module TopModule (
    input  wire clk,  // Clock signal
    input  wire rst_n,  // Reset signal (active low)
    input  wire [31:0] in,  // Input vector
    output wire [31:0] out  // Output vector with bytes reversed
);

    reg [1:0] state;  // State machine state
    reg [31:0] byte1, byte2, byte3, byte4;  // Registers to hold the bytes
    reg [31:0] out_reg;  // Register to hold the output vector

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 0;
            byte1 <= 0;
            byte2 <= 0;
            byte3 <= 0;
            byte4 <= 0;
            out_reg <= 0;
        end else begin
            case (state)
                2'd0: begin  // Extract bytes from input vector
                    byte1 <= in[7:0];
                    byte2 <= in[15:8];
                    byte3 <= in[23:16];
                    byte4 <= in[31:24];
                    state <= 2'd1;
                end
                2'd1: begin  // Rearrange bytes
                    out_reg <= {byte4, byte3, byte2, byte1};
                    state <= 2'd2;
                end
                2'd2: begin  // Assemble output vector
                    out <= out_reg;
                    state <= 2'd0;
                end
                default: begin
                    state <= 2'd0;
                end
            endcase
        end
    end

endmodule