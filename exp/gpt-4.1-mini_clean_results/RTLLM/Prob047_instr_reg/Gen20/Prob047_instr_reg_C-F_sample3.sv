module instr_reg (
    input  wire        clk,
    input  wire        rst,        // Active low reset
    input  wire [1:0]  fetch,      // Fetch source control: 01 for ins_p1, 10 for ins_p2
    input  wire [7:0]  data,       // Incoming 8-bit instruction data
    output wire [2:0]  ins,        // High 3 bits of instruction from ins_p1
    output wire [4:0]  ad1,        // Low 5 bits of instruction from ins_p1
    output wire [7:0]  ad2         // Full 8-bit data from ins_p2 (if last fetched was p2)
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;
    reg       last_fetched_p2;

    wire ce = (fetch == 2'b01) || (fetch == 2'b10);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1          <= 8'b0;
            ins_p2          <= 8'b0;
            last_fetched_p2 <= 1'b0;
        end else if (ce) begin
            if (fetch == 2'b01) begin
                ins_p1          <= data;
                // last_fetched_p2 unchanged, since source is p1
            end else if (fetch == 2'b10) begin
                ins_p2          <= data;
                last_fetched_p2 <= 1'b1;
            end
        end
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = last_fetched_p2 ? ins_p2 : 8'b0;

endmodule