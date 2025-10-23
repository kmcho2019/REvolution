module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define the states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Declare and initialize the current state variable
reg current_state = OFF;

// Sequential logic: update current state on clock edge and output
always @(posedge clk)
begin
    if (reset) begin
        current_state <= OFF; // Synchronous reset
        out <= 1'b0;
    end
    else begin
        if (current_state == OFF && j == 1'b1) begin
            current_state <= ON;
            out <= 1'b1;
        end
        else if (current_state == ON && k == 1'b1) begin
            current_state <= OFF;
            out <= 1'b0;
        end
        else begin
            out <= current_state; // Moore output is a function of the state
        end
    end
end

endmodule