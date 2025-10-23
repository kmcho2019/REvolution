module freq_diveven #(
    parameter NUM_DIV = 8 // Must be an even number
) (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output reg  clk_div  // Divided clock output signal
);

reg [3:0] cnt; // Counter to track clock cycles
reg [1:0] state; // State machine: 0 - IDLE, 1 - TOGGLE
localparam IDLE = 2'b00, TOGGLE = 2'b01;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0;
        state <= IDLE;
        clk_div <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (cnt == (NUM_DIV / 2 - 1)) begin
                    state <= TOGGLE;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            TOGGLE: begin
                cnt <= 4'b0;
                clk_div <= ~clk_div;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule