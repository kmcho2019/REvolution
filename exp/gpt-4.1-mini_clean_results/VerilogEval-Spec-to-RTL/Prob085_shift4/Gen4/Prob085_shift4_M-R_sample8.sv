module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Function to compute next state
function [3:0] next_state;
    input load_i;
    input ena_i;
    input [3:0] data_i;
    input [3:0] q_i;
    begin
        if (load_i)
            next_state = data_i;
        else if (ena_i)
            next_state = {1'b0, q_i[3:1]};
        else
            next_state = q_i;
    end
endfunction

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0000;
    else
        q <= next_state(load, ena, data, q);
end

endmodule