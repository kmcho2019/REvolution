module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] prev_inputs;

    always @(*) begin
        if ((x == prev_inputs[1]) && (y == prev_inputs[0]))
            z = 1;
        else
            z = 0;
    end

    always @(posedge x or posedge y) begin
        prev_inputs <= {x, y};
    end
endmodule