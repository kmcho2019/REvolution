module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

// Define states
enum logic [1:0] {
    Idle,
    Byte1,
    Byte2,
    Done
} state, next_state;

// Define registers
logic [7:0] byte1, byte2;
logic [23:0] out_bytes_reg;

// FSM logic
always_comb begin
    next_state = state;
    case(state)
        Idle: begin
            if (in[3]) begin
                next_state = Byte1;
            end
        end
        Byte1: begin
            next_state = Byte2;
        end
        Byte2: begin
            next_state = Done;
        end
        Done: begin
            next_state = Idle;
        end
    endcase
end

// Datapath logic
always_comb begin
    out_bytes = out_bytes_reg;
    done = (state == Done);
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        out_bytes_reg <= 24'd0;
    end else begin
        state <= next_state;
        case(next_state)
            Byte1: begin
                byte1 <= in;
            end
            Byte2: begin
                byte2 <= in;
            end
            Done: begin
                out_bytes_reg <= {byte1, byte2, in};
            end
        endcase
    end
end

endmodule