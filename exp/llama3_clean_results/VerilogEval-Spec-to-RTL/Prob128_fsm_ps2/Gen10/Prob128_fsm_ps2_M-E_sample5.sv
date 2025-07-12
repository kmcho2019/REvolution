module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states
enum logic [1:0] {
    IDLE,
    MESSAGE_IN_PROGRESS
} state, next_state;

// Counter for bytes received since last message boundary
logic [1:0] byte_counter;
always_ff @(posedge clk) begin
    if (reset) begin
        byte_counter <= 0;
    end else if (state == IDLE && in[3]) begin
        byte_counter <= 1; // Reset and start counting from 1
    end else if (state == MESSAGE_IN_PROGRESS) begin
        byte_counter <= byte_counter + 1;
    end else if (state == MESSAGE_IN_PROGRESS && byte_counter == 2) begin
        byte_counter <= 0; // Reset after reaching 2 (third byte received)
    end else begin
        byte_counter <= byte_counter;
    end
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = MESSAGE_IN_PROGRESS;
            end else begin
                next_state = IDLE;
            end
        end
        MESSAGE_IN_PROGRESS: begin
            if (byte_counter == 2) begin
                next_state = IDLE; // Return to IDLE after third byte
            end else begin
                next_state = MESSAGE_IN_PROGRESS;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Done signal generation
assign done = (state == MESSAGE_IN_PROGRESS && byte_counter == 2);

endmodule