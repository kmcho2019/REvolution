module TimeSharedModule(
    input clk,
    input x,
    input y,
    output reg z
);
    reg [1:0] state;
    reg a_out, b_out;
    reg temp_or, temp_and;
    
    // Shared computation unit
    wire shared_out = (state[0]) ? ((x ^ y) & x) : ((~x & ~y) | (x & y));
    
    always @(posedge clk) begin
        case(state)
            2'b00: begin
                // Compute ModuleA function
                a_out <= shared_out;
                state <= 2'b01;
            end
            2'b01: begin
                // Compute ModuleB function
                b_out <= shared_out;
                state <= 2'b10;
            end
            2'b10: begin
                // Combine results
                temp_or <= a_out | b_out;
                temp_and <= a_out & b_out;
                state <= 2'b11;
            end
            2'b11: begin
                // Final XOR
                z <= temp_or ^ temp_and;
                state <= 2'b00;
            end
        endcase
    end
    
    initial begin
        state = 2'b00;
        a_out = 0;
        b_out = 0;
        temp_or = 0;
        temp_and = 0;
        z = 0;
    end
endmodule

module TopModule(
    input clk,
    input x,
    input y,
    output z
);
    TimeSharedModule tsm(
        .clk(clk),
        .x(x),
        .y(y),
        .z(z)
    );
endmodule