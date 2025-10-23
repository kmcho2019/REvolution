module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // current state
reg [0:0] next_state; // next state

// state encoding
parameter A = 1'b0;
parameter B = 1'b1;

// output logic
assign out = (state == B)? 1'b1 : 1'b0;

// state transition logic
always @(*) begin
    case(state)
        A: begin
            if(in == 1'b1)
                next_state = A;
            else
                next_state = B;
        end
        B: begin
            if(in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end
    endcase
end

// synchronous reset
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

endmodule