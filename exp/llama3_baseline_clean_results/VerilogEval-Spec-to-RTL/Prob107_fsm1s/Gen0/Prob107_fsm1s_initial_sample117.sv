module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state; // two states: B (2'b00) and A (2'b01)
reg [1:0] next_state;

// output logic
always @(*) begin
    case (state)
        2'b00: out = 1'b1; // B state
        2'b01: out = 1'b0; // A state
        default: out = 1'b0;
    endcase
end

// next state logic
always @(*) begin
    case (state)
        2'b00: begin
            if (~in) begin
                next_state = 2'b01; // B to A on in=0
            end else begin
                next_state = 2'b00; // B to B on in=1
            end
        end
        2'b01: begin
            if (~in) begin
                next_state = 2'b00; // A to B on in=0
            end else begin
                next_state = 2'b01; // A to A on in=1
            end
        end
        default: next_state = 2'b00;
    endcase
end

// state update logic
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to state B
    end else begin
        state <= next_state;
    end
end

initial state = 2'b00;

endmodule