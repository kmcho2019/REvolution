module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] nextState;

parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        A: if(w) begin
            nextState <= A;
        end else begin
            nextState <= B;
        end
        B: if(w) begin
            nextState <= D;
        end else begin
            nextState <= C;
        end
        C: if(w) begin
            nextState <= D;
        end else begin
            nextState <= E;
        end
        D: if(w) begin
            nextState <= A;
        end else begin
            nextState <= F;
        end
        E: if(w) begin
            nextState <= D;
        end else begin
            nextState <= E;
        end
        F: if(w) begin
            nextState <= D;
        end else begin
            nextState <= C;
        end
    endcase
end

assign z = (state == E) || (state == F);

endmodule