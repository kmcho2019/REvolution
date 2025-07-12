module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] current_state; // current state
reg [1:0] next_state; // next state

// state encoding
parameter B = 2'b00; // State B
parameter A = 2'b01; // State A

always @ (posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    case(current_state)
        B: begin
            if(in == 1'b0) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        A: begin
            if(in == 1'b0) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        default: begin
            next_state <= B;
        end
    endcase
end

always @ (*) begin
    case(current_state)
        B: out <= 1'b1;
        A: out <= 1'b0;
        default: out <= 1'b1;
    endcase
end

endmodule