module instr_reg (
    input  wire        clk,
    input  wire        rst,     // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Single always block with asynchronous active-low reset
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (fetch == 2'b01) begin
                ins_p1 <= data;
            end
            if (fetch == 2'b10) begin
                ins_p2 <= data;
            end
            // else retain previous values
        end
    end

    // Outputs derived combinationally from stored instructions
    assign ins = ins_p1[7:5];  // opcode or operation (high 3 bits)
    assign ad1 = ins_p1[4:0];  // register address (low 5 bits)
    assign ad2 = ins_p2;       // full 8-bit data from second source

endmodule