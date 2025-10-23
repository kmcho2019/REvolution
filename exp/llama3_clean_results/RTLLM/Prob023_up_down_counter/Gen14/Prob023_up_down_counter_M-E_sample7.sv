module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input load,        // Load signal
    input [WIDTH-1:0] load_value,  // Load value
    input up_down,     // Control signal for counting direction
    output reg [WIDTH-1:0] count  // Output representing the current counter value
);

reg [WIDTH-1:0] next_count;

always @ (posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (load) begin
        count <= load_value;
    end else if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule