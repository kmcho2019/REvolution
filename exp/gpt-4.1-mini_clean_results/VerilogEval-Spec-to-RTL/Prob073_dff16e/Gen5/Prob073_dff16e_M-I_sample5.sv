module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

    wire update_en = byteena != 2'b00;

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else if (update_en) begin
            // Update upper byte if byteena[1] set, else keep old upper byte
            // Update lower byte if byteena[0] set, else keep old lower byte
            q <= {byteena[1] ? d[15:8] : q[15:8],
                  byteena[0] ? d[7:0]  : q[7:0]};
        end
        // else retain q without toggling
    end

endmodule