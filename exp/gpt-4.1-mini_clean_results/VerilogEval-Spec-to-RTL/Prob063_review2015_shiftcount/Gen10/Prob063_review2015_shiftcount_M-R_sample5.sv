module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Function to compute next state of q
    function [3:0] next_state;
        input [3:0] current;
        input shift_enable;
        input count_enable;
        input data_in;
        begin
            if (shift_enable)
                next_state = {current[2:0], data_in};  // shift left MSB-first
            else if (count_enable)
                next_state = current - 1;
            else
                next_state = current;
        end
    endfunction

    always @(posedge clk) begin
        q <= next_state(q, shift_ena, count_ena, data);
    end

endmodule