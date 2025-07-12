module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Function to compute next state based on current q, load, ena, and data
    function [99:0] next_state;
        input [99:0] curr_q;
        input load_sig;
        input [1:0] ena_sig;
        input [99:0] data_in;

        begin
            if (load_sig) begin
                next_state = data_in;
            end else if (ena_sig == 2'b10) begin
                // Rotate left by one bit
                next_state = {curr_q[98:0], curr_q[99]};
            end else if (ena_sig == 2'b01) begin
                // Rotate right by one bit
                next_state = {curr_q[0], curr_q[99:1]};
            end else begin
                // No rotation
                next_state = curr_q;
            end
        end
    endfunction

    // Sequential logic: update q on rising clock edge with function result
    always @(posedge clk) begin
        q <= next_state(q, load, ena, data);
    end

endmodule