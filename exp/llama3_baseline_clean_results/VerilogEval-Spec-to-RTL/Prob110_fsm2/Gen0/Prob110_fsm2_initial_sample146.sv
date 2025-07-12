module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state;  // Enumerated states: OFF = 2'b00, ON = 2'b01
parameter OFF = 2'b00, ON = 2'b01;

always @(*) begin
    case(state)
        OFF: begin
            if(j)
                out = 0;
            else
                out = 0;
        end
        ON: begin
            if(k)
                out = 1;
            else
                out = 1;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if(j)
                    state <= ON;
                else
                    state <= OFF;
            end
            ON: begin
                if(k)
                    state <= OFF;
                else
                    state <= ON;
            end
        endcase
    end
end

always @(*) begin
    if(state == OFF)
        out = 0;
    else if(state == ON)
        out = 1;
end
endmodule