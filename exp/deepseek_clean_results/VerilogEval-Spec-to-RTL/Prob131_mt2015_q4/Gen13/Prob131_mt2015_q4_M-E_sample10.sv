module TimeSharedCore(
    input clk,
    input x,
    input y,
    output reg z
);
    reg [1:0] state;
    reg temp_a, temp_b;
    
    always @(posedge clk) begin
        case(state)
            2'b00: begin
                // Compute ModuleA function (x & ~y)
                temp_a <= x & ~y;
                state <= 2'b01;
            end
            2'b01: begin
                // Compute ModuleB function (~(x ^ y))
                temp_b <= ~(x ^ y);
                state <= 2'b10;
            end
            2'b10: begin
                // Compute final XOR (equivalent to original logic)
                z <= temp_a ^ temp_b;
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
endmodule

module TopModule(
    input clk,
    input x,
    input y,
    output z
);
    TimeSharedCore core(
        .clk(clk),
        .x(x),
        .y(y),
        .z(z)
    );
endmodule