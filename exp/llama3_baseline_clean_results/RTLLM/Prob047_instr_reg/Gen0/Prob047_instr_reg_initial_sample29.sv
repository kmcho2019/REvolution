module instr_reg(
    input clk, // Clock signal
    input rst, // Active low reset signal
    input [1:0] fetch, // Control signal for instruction source
    input [7:0] data, // 8-bit data input for instruction
    output [2:0] ins, // High 3 bits of the instruction
    output [4:0] ad1, // Low 5 bits of the instruction
    output [7:0] ad2 // Full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register for instruction storage
reg [7:0] ins_p2; // Second 8-bit register for instruction storage

// Sequential logic to update registers based on clock and reset
always @(posedge clk or negedge rst) begin
    if (~rst) begin // Active low reset
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else if (fetch == 2'b01) begin // Fetch from data into ins_p1
        ins_p1 <= data;
    end else if (fetch == 2'b10) begin // Fetch from data into ins_p2
        ins_p2 <= data;
    end else begin // Retain previous values
        ins_p1 <= ins_p1;
        ins_p2 <= ins_p2;
    end
end

// Combinational logic to derive outputs
always @(*) begin
    ins = ins_p1[7:5]; // High 3 bits of ins_p1
    ad1 = ins_p1[4:0]; // Low 5 bits of ins_p1
    ad2 = ins_p2; // Full 8 bits of ins_p2
end

endmodule