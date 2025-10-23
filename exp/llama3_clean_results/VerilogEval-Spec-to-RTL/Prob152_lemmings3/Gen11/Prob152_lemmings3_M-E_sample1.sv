module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the micro-instructions
enum logic [2:0] {
    IDLE = 3'b000,
    SWITCH_DIRECTION = 3'b001,
    START_DIGGING = 3'b010,
    FALL = 3'b100
} microcode;

// Define the microcode program
logic [2:0] microcode_program [7:0];

// Initialize the microcode program
initial begin
    microcode_program[0] = IDLE;
    microcode_program[1] = SWITCH_DIRECTION;
    microcode_program[2] = START_DIGGING;
    microcode_program[3] = FALL;
    microcode_program[4] = IDLE;
    microcode_program[5] = SWITCH_DIRECTION;
    microcode_program[6] = START_DIGGING;
    microcode_program[7] = FALL;
end

// Define the program counter (PC)
logic [2:0] pc;

// Define the walking direction
enum logic [0:0] {
    LEFT = 1'b0,
    RIGHT = 1'b1
} walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        pc <= 0;
        walk_direction <= LEFT;
    end else begin
        case (microcode_program[pc])
            IDLE: begin
                if (bump_left && walk_direction == LEFT) begin
                    walk_direction <= RIGHT;
                    pc <= pc + 1;
                end else if (bump_right && walk_direction == RIGHT) begin
                    walk_direction <= LEFT;
                    pc <= pc + 1;
                end else if (dig) begin
                    pc <= pc + 2;
                end else if (!ground) begin
                    pc <= pc + 3;
                end
            end
            SWITCH_DIRECTION: begin
                pc <= pc + 1;
            end
            START_DIGGING: begin
                pc <= pc + 1;
            end
            FALL: begin
                if (ground) begin
                    pc <= 0;
                end
            end
        endcase
    end
end

// Output logic
assign walk_left = (walk_direction == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (walk_direction == RIGHT) ? 1'b1 : 1'b0;
assign aaah = (microcode_program[pc] == FALL) ? 1'b1 : 1'b0;
assign digging = (microcode_program[pc] == START_DIGGING) ? 1'b1 : 1'b0;

endmodule