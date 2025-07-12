module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// ROM contents for state transitions and output logic
reg [2:0] rom_next_state [6][2];
reg [0:0] rom_output [6][2];

initial begin
    // Initialize ROM contents
    rom_next_state[A][0] = B;
    rom_next_state[A][1] = A;
    rom_output[A][0] = 0;
    rom_output[A][1] = 0;

    rom_next_state[B][0] = C;
    rom_next_state[B][1] = D;
    rom_output[B][0] = 0;
    rom_output[B][1] = 0;

    rom_next_state[C][0] = E;
    rom_next_state[C][1] = D;
    rom_output[C][0] = 0;
    rom_output[C][1] = 0;

    rom_next_state[D][0] = F;
    rom_next_state[D][1] = A;
    rom_output[D][0] = 0;
    rom_output[D][1] = 0;

    rom_next_state[E][0] = E;
    rom_next_state[E][1] = D;
    rom_output[E][0] = 1;
    rom_output[E][1] = 1;

    rom_next_state[F][0] = C;
    rom_next_state[F][1] = D;
    rom_output[F][0] = 1;
    rom_output[F][1] = 1;
end

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table and output logic using ROM
always @(*) begin
    case (current_state)
        A: begin
            next_state = rom_next_state[A][w];
            z = rom_output[A][w];
        end
        B: begin
            next_state = rom_next_state[B][w];
            z = rom_output[B][w];
        end
        C: begin
            next_state = rom_next_state[C][w];
            z = rom_output[C][w];
        end
        D: begin
            next_state = rom_next_state[D][w];
            z = rom_output[D][w];
        end
        E: begin
            next_state = rom_next_state[E][w];
            z = rom_output[E][w];
        end
        F: begin
            next_state = rom_next_state[F][w];
            z = rom_output[F][w];
        end
        default: begin
            next_state = A;
            z = 0;
        end
    endcase
end

endmodule