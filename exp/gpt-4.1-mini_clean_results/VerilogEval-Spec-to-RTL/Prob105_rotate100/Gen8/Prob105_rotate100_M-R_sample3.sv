module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Combinational function to calculate next q value
    function [99:0] next_q_value;
        input [99:0] current_q;
        input [1:0] ena_local;
        input load_local;
        input [99:0] data_local;
        begin
            if (load_local) begin
                next_q_value = data_local;
            end else begin
                case (ena_local)
                    2'b01: 
                        // Rotate right by one bit
                        next_q_value = {current_q[0], current_q[99:1]};
                    2'b10: 
                        // Rotate left by one bit
                        next_q_value = {current_q[98:0], current_q[99]};
                    default:
                        // No change
                        next_q_value = current_q;
                endcase
            end
        end
    endfunction

    always @(posedge clk) begin
        q <= next_q_value(q, ena, load, data);
    end

endmodule