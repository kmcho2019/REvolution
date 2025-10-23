module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

integer i;
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign next_state = {
    // Leftmost cell
    (current_state[0] && !current_state[1]) ? 1'b0 :
    (!current_state[0] && current_state[1]) ? 1'b1 :
    (current_state[0] && current_state[1]) ? 1'b1 :
    1'b0,

    // Middle cells
    {509{(
        (!current_state[i] && !current_state[i+1] && !current_state[i+2]) ? 1'b0 :
        (!current_state[i] && !current_state[i+1] && current_state[i+2]) ? 1'b1 :
        (!current_state[i] && current_state[i+1] && !current_state[i+2]) ? 1'b1 :
        (!current_state[i] && current_state[i+1] && current_state[i+2]) ? 1'b1 :
        (current_state[i] && !current_state[i+1] && !current_state[i+2]) ? 1'b0 :
        (current_state[i] && !current_state[i+1] && current_state[i+2]) ? 1'b1 :
        (current_state[i] && current_state[i+1] && !current_state[i+2]) ? 1'b1 :
        (current_state[i] && current_state[i+1] && current_state[i+2]) ? 1'b0 :
        1'b0)
    } for (i = 0; i < 509; i = i + 1)),

    // Rightmost cell
    (current_state[511] && !current_state[510]) ? 1'b0 :
    (!current_state[511] && current_state[510]) ? 1'b1 :
    (current_state[511] && current_state[510]) ? 1'b1 :
    1'b0
};

assign q = current_state;

endmodule