module instr_reg (
    input  wire        clk,
    input  wire        rst,       // active low reset (synchronous)
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    wire we_p1 = (fetch == 2'b01);
    wire we_p2 = (fetch == 2'b10);

    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (we_p1)
                ins_p1 <= data;
            if (we_p2)
                ins_p2 <= data;
            // retain previous values if no write enable
        end
    end

    assign ins = ins_p1[7:5];  // opcode from ins_p1
    assign ad1 = ins_p1[4:0];  // reg addr from ins_p1
    assign ad2 = ins_p2;       // full data from ins_p2

endmodule