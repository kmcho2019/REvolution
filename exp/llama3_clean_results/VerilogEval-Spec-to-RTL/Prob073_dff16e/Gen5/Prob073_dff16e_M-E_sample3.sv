module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    reg [15:0] reg_file;

    always @(posedge clk) begin
        if (!resetn) begin
            reg_file <= 16'd0;
        end else begin
            case (byteena)
                2'b00: reg_file <= reg_file;
                2'b01: reg_file <= {reg_file[15:8], d[7:0]};
                2'b10: reg_file <= {d[15:8], reg_file[7:0]};
                2'b11: reg_file <= d;
            endcase
        end
    end

    assign q = reg_file;

endmodule