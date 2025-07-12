module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] mem;
reg [2:0] addr;
reg [2:0] counter;

// Counter logic
always @(posedge clk) begin
    if (enable) begin
        counter <= counter + 1;
        if (counter == 8) begin
            counter <= 0;
        end
    end
end

// Memory write logic
always @(posedge clk) begin
    if (enable) begin
        mem[counter] <= S;
    end
end

// Address generation logic
assign addr = {A, B, C};

// Memory read logic
always @(*) begin
    case (addr)
        3'b000: Z = mem[0];
        3'b001: Z = mem[1];
        3'b010: Z = mem[2];
        3'b011: Z = mem[3];
        3'b100: Z = mem[4];
        3'b101: Z = mem[5];
        3'b110: Z = mem[6];
        3'b111: Z = mem[7];
    endcase
end

endmodule