module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam HIGH     = 2'b01;
    localparam CAPTURED = 2'b10;

    reg [1:0] state [0:31];  // State for each bit
    reg [31:0] out_reg;

    // Generate output from state
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : output_gen
            assign out[i] = (state[i] == CAPTURED);
        end
    endgenerate

    always @(posedge clk) begin
        if (reset) begin
            for (integer j = 0; j < 32; j = j + 1) begin
                state[j] <= IDLE;
            end
            out_reg <= 32'b0;
        end else begin
            for (integer j = 0; j < 32; j = j + 1) begin
                case (state[j])
                    IDLE: begin
                        if (in[j]) state[j] <= HIGH;
                    end
                    HIGH: begin
                        if (!in[j]) state[j] <= CAPTURED;
                        else if (!in[j]) state[j] <= IDLE;
                    end
                    CAPTURED: begin
                        // Stay in captured state until reset
                    end
                endcase
            end
        end
    end

endmodule