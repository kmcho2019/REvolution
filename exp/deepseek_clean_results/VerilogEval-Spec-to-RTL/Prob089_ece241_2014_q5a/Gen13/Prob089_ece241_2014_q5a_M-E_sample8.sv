module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    parameter DEPTH = 8;  // Optimal depth for typical cases
    reg [DEPTH-1:0] buffer;
    reg found_one;
    reg [2:0] ptr;  // Points to current output position

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            buffer <= 0;
            found_one <= 0;
            ptr <= 0;
            z <= 0;
        end else begin
            if (!found_one) begin
                if (x) begin
                    found_one <= 1;
                    z <= x;
                end else begin
                    if (ptr < DEPTH-1) begin
                        buffer[ptr] <= x;
                        ptr <= ptr + 1;
                    end
                    z <= buffer[0];
                    buffer <= buffer >> 1;
                end
            end else begin
                z <= ~x;
            end
        end
    end

endmodule