module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] prev_xy;
    
    always @(*) begin
        case ({x, y, prev_xy})
            4'b0000, 4'b1111: z = 1'b1;
            default: z = 1'b0;
        endcase
    end
    
    always @(posedge x or posedge y) begin
        prev_xy <= {x, y};
    end
endmodule