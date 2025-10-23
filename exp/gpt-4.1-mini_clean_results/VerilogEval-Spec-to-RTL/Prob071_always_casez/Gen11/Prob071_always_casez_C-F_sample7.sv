module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

    // Function to find the position of the least significant set bit
    function [2:0] priority_encode;
        input [7:0] value;
        integer i;
        begin
            priority_encode = 3'd0; // default to zero if none set
            for (i = 0; i < 8; i = i + 1) begin
                if (value[i]) begin
                    priority_encode = i[2:0];
                    disable for; // break out of loop once first set bit found
                end
            end
        end
    endfunction

    always @(*) begin
        pos = priority_encode(in);
    end

endmodule