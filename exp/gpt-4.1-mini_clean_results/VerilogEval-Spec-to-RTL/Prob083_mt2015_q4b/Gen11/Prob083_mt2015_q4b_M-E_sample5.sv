module TopModule (
    input  wire clk,
    input  wire rst_n,
    input  wire x,
    input  wire y,
    output reg  z
);

    // State encoding corresponds directly to input vector {x,y}
    // 2'b00 and 2'b11 produce z=1, others produce z=0.
    reg [1:0] state;

    // Update state synchronously on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;  // Initialize to 00 state as per initial waveform
        end else begin
            state <= {x, y};
        end
    end

    // Output z based on current state
    always @(*) begin
        case (state)
            2'b00, 2'b11: z = 1'b1;
            default:      z = 1'b0;
        endcase
    end

endmodule