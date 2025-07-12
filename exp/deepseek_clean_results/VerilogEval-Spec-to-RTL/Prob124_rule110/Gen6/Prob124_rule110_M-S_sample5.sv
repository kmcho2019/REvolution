module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    function automatic rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 0;
                3'b110: rule110 = 1;
                3'b101: rule110 = 1;
                3'b100: rule110 = 0;
                3'b011: rule110 = 1;
                3'b010: rule110 = 1;
                3'b001: rule110 = 1;
                3'b000: rule110 = 0;
            endcase
        end
    endfunction

    reg [511:0] next_q;
    wire [513:0] q_ext = {1'b0, q, 1'b0};
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            next_q[i] = rule110(q_ext[i+2], q_ext[i+1], q_ext[i]);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule