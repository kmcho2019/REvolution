module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] count;  // 0-4 counter for states

    // State encoding mapping
    wire [2:0] state = 
        (count == 0) ? 3'b000 :
        (count == 1) ? 3'b001 :
        (count == 2) ? 3'b010 :
        (count == 3) ? 3'b011 : 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else begin
            case (count)
                0: count <= x ? 1 : 0;      // 000 → 001 if x=1, else 000
                1: count <= x ? 4 : 1;      // 001 → 100 if x=1, else 001
                2: count <= x ? 1 : 2;      // 010 → 001 if x=1, else 010
                3: count <= x ? 2 : 1;      // 011 → 010 if x=1, else 001
                4: count <= x ? 4 : 3;      // 100 → 100 if x=1, else 011
            endcase
        end
    end

    // Output is high when count is 3 or 4 (states 011 or 100)
    assign z = (count == 3) || (count == 4);

endmodule