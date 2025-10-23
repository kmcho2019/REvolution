module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Create a packed array of inputs for easy indexing: index 0->b, 1->e, 2->a, 3->d
    wire [3:0] inputs_arr [0:3];
    assign inputs_arr[0] = b;
    assign inputs_arr[1] = e;
    assign inputs_arr[2] = a;
    assign inputs_arr[3] = d;

    always @(*) begin
        if (c < 4) begin
            q = inputs_arr[c];
        end else begin
            q = 4'hF;
        end
    end

endmodule