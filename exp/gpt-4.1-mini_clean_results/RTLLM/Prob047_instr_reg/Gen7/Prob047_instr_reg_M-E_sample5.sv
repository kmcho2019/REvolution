module instr_reg (
    input  wire        clk,
    input  wire        rst,      // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;
    reg       valid_p1;
    reg       valid_p2;

    wire fetch_p1 = (fetch == 2'b01);
    wire fetch_p2 = (fetch == 2'b10);

    always @(posedge clk) begin
        if (!rst) begin
            ins_p1   <= 8'd0;
            ins_p2   <= 8'd0;
            valid_p1 <= 1'b0;
            valid_p2 <= 1'b0;
        end else begin
            if (fetch_p1) begin
                ins_p1   <= data;
                valid_p1 <= 1'b1;
            end
            if (fetch_p2) begin
                ins_p2   <= data;
                valid_p2 <= 1'b1;
            end
        end
    end

    // Outputs reflect valid state; zero if no valid data
    assign ins = valid_p1 ? ins_p1[7:5] : 3'b000;
    assign ad1 = valid_p1 ? ins_p1[4:0] : 5'b00000;
    assign ad2 = valid_p2 ? ins_p2 : 8'b00000000;

endmodule