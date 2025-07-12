module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    reg [31:0] temp_out;

    always @(in) begin
        if (in[7] == 1'b0) begin
            temp_out = {24'd0, in};
        end else begin
            temp_out = {24'd-1, in};
        end
    end

    assign out = temp_out;

endmodule