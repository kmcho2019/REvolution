module TopModule (
    input clk,
    input a,
    input b,
    output reg q
);

    reg state;

    localparam IDLE = 1'b0;
    localparam ACTIVE = 1'b1;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                q <= 1'b0;
                if (a & b) state <= ACTIVE;
            end
            ACTIVE: begin
                q <= a & b;
                if (!(a & b)) state <= IDLE;
            end
        endcase
    end

endmodule