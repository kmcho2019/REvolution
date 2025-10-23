module TopModule (
    input clk,          // Added clock input
    input reset,        // Added reset input
    input [7:0] in,     // Input byte
    output reg parity   // Parity bit
);
    reg [2:0] counter;
    reg [7:0] shift_reg;
    reg running_parity;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 3'd0;
            shift_reg <= 8'd0;
            running_parity <= 1'b0;
            parity <= 1'b0;
        end else begin
            if (counter == 3'd0) begin
                // Load new input and start calculation
                shift_reg <= in;
                running_parity <= 1'b0;
                counter <= 3'd1;
            end else if (counter <= 3'd7) begin
                // Process one bit per cycle
                running_parity <= running_parity ^ shift_reg[0];
                shift_reg <= shift_reg >> 1;
                counter <= counter + 1;
            end else begin
                // Calculation complete
                parity <= running_parity;
                counter <= 3'd0;
            end
        end
    end
endmodule