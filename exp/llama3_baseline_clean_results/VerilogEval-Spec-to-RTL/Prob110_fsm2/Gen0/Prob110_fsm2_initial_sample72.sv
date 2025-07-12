module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

// State encoding
parameter OFF = 2'b00;
parameter ON = 2'b01;

always @(*) begin
    case(state)
        OFF: begin
            if(j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if(k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule