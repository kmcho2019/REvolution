module instr_reg (
    input  wire        clk,
    input  wire        rst,       // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    wire        fetch_p1_en = (fetch == 2'b01);
    wire        fetch_p2_en = (fetch == 2'b10);

    reg [7:0] next_ins_p1;
    reg [7:0] next_ins_p2;

    // Combinational logic for next state
    always @(*) begin
        if (!rst) begin
            next_ins_p1 = 8'b0;
            next_ins_p2 = 8'b0;
        end else begin
            next_ins_p1 = ins_p1;
            next_ins_p2 = ins_p2;

            if (fetch_p1_en)
                next_ins_p1 = data;
            if (fetch_p2_en)
                next_ins_p2 = data;
        end
    end

    // Synchronous update on clk rising edge
    always @(posedge clk) begin
        ins_p1 <= next_ins_p1;
        ins_p2 <= next_ins_p2;
    end

    // Outputs from stored instructions
    assign ins = ins_p1[7:5];  // opcode: high 3 bits
    assign ad1 = ins_p1[4:0];  // register address: low 5 bits
    assign ad2 = ins_p2;       // full 8-bit data from second source

endmodule