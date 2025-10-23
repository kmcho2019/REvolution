module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;

// State machine logic
always @(posedge clk or posedge areset)
begin
    if(areset)
    begin
        state <= A;
        out <= 1'b0;
    end
    else
    begin
        case(state)
            A: 
            begin
                if(in == 1'b0)
                    state <= A;
                else
                    state <= B;
                out <= 1'b0;
            end
            B: 
            begin
                if(in == 1'b0)
                    state <= C;
                else
                    state <= B;
                out <= 1'b0;
            end
            C: 
            begin
                if(in == 1'b0)
                    state <= A;
                else
                    state <= D;
                out <= 1'b0;
            end
            D: 
            begin
                if(in == 1'b0)
                    state <= C;
                else
                    state <= B;
                out <= 1'b1;
            end
            default: 
            begin
                state <= A;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule