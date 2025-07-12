module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        2'b00: begin // A
            if(!in)
                next_state = 2'b00;
            else
                next_state = 2'b01;
            out = 0;
        end
        2'b01: begin // B
            if(!in)
                next_state = 2'b10;
            else
                next_state = 2'b01;
            out = 0;
        end
        2'b10: begin // C
            if(!in)
                next_state = 2'b00;
            else
                next_state = 2'b11;
            out = 0;
        end
        2'b11: begin // D
            if(!in)
                next_state = 2'b10;
            else
                next_state = 2'b01;
            out = 1;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule