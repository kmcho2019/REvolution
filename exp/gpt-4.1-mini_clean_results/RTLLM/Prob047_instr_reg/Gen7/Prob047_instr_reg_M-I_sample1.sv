module instr_reg (
    input  wire        clk,
    input  wire        rst,   // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            // Update ins_p1 only if fetch == 2'b01
            if (fetch == 2'b01) begin
                ins_p1 <= data;
            end
            // Update ins_p2 only if fetch == 2'b10
            if (fetch == 2'b10) begin
                ins_p2 <= data;
            end
            // Otherwise, retain previous values (no else needed)
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule