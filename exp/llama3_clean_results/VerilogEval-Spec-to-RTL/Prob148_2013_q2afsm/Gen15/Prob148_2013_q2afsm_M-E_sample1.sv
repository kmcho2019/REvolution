module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [1:0] priority;

always @(*) begin
    if (r[0]) priority = 2'b00;
    else if (r[1]) priority = 2'b01;
    else if (r[2]) priority = 2'b10;
    else priority = 2'b11;
end

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else begin
        case (state)
            3'b000: 
                case (priority)
                    2'b00: state <= 3'b001;
                    2'b01: state <= 3'b010;
                    2'b10: state <= 3'b011;
                    default: state <= 3'b000;
                endcase
            3'b001: 
                if (r[0]) state <= 3'b001;
                else state <= 3'b000;
            3'b010: 
                if (r[1]) state <= 3'b010;
                else state <= 3'b000;
            3'b011: 
                if (r[2]) state <= 3'b011;
                else state <= 3'b000;
            default: state <= 3'b000;
        endcase
    end
end

assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule