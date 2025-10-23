module TopModule(
    input         clk,
    input         areset,
    input         x,
    output logic  z
);

// One-hot encoding for states
logic [1:0] state;
logic [1:0] next_state;

// Assign one-hot encodings
localparam A = 2'b01;
localparam B = 2'b10;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        A: begin
            if (x) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = A;
                z = 1'b0;
            end
        end
        B: begin
            next_state = B;
            z = 1'b1;
        end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

endmodule