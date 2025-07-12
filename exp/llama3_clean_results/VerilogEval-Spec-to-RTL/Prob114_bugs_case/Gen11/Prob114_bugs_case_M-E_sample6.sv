module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    reg [3:0] out_reg;
    reg valid_reg;

    // Define an array of valid codes and their corresponding outputs
    reg [7:0] valid_codes [9:0] = {
        8'h45, 8'h16, 8'h1e, 8'h26, 8'h25,
        8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
    };

    reg [3:0] outputs [9:0] = {
        4'h0, 4'h1, 4'h2, 4'h3, 4'h4,
        4'h5, 4'h6, 4'h7, 4'h8, 4'h9
    };

    // Combinational logic to generate output 'out' and valid signal
    always @(*) begin
        out_reg = 4'h0;
        valid_reg = 1'b0;
        for (int i = 0; i < 10; i++) begin
            if (code == valid_codes[i]) begin
                out_reg = outputs[i];
                valid_reg = 1'b1;
            end
        end
    end

    assign out = out_reg;
    assign valid = valid_reg;

endmodule