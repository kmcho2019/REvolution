module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] prev_state;

    always @(*) begin
        case({x, y})
            2'b00: z = 1'b1;
            2'b11: z = 1'b1;
            2'b10: z = 1'b0;
            2'b01: begin
                if (prev_state == 2'b10)
                    z = 1'b0;
                else
                    z = 1'b0;
            end
        endcase
    end

    always @(posedge x or posedge y) begin
        prev_state <= {x, y};
    end
endmodule