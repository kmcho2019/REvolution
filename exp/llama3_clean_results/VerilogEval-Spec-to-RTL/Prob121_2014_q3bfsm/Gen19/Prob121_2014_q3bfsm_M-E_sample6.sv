module MicrocodedFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg [1:0] output; // output

// Microcode ROM
reg [2:0] microcode_rom [8:0]; // next state and output information
reg [1:0] output_rom [8:0]; // output information

initial begin
    // Initialize microcode ROM
    microcode_rom[0] = 3'b000; // state 000, x = 0
    microcode_rom[1] = 3'b001; // state 000, x = 1
    microcode_rom[2] = 3'b001; // state 001, x = 0
    microcode_rom[3] = 3'b100; // state 001, x = 1
    microcode_rom[4] = 3'b010; // state 010, x = 0
    microcode_rom[5] = 3'b001; // state 010, x = 1
    microcode_rom[6] = 3'b001; // state 011, x = 0
    microcode_rom[7] = 3'b010; // state 011, x = 1
    microcode_rom[8] = 3'b100; // state 100, x = 0

    // Initialize output ROM
    output_rom[0] = 2'b00; // state 000, x = 0
    output_rom[1] = 2'b00; // state 000, x = 1
    output_rom[2] = 2'b00; // state 001, x = 0
    output_rom[3] = 2'b00; // state 001, x = 1
    output_rom[4] = 2'b00; // state 010, x = 0
    output_rom[5] = 2'b00; // state 010, x = 1
    output_rom[6] = 2'b01; // state 011, x = 0
    output_rom[7] = 2'b01; // state 011, x = 1
    output_rom[8] = 2'b01; // state 100, x = 0
end

// Controller
always @(*) begin
    case (y)
        3'b000: begin
            if (x) begin
                next_y = microcode_rom[1];
                output = output_rom[1];
            end else begin
                next_y = microcode_rom[0];
                output = output_rom[0];
            end
        end
        3'b001: begin
            if (x) begin
                next_y = microcode_rom[3];
                output = output_rom[3];
            end else begin
                next_y = microcode_rom[2];
                output = output_rom[2];
            end
        end
        3'b010: begin
            if (x) begin
                next_y = microcode_rom[5];
                output = output_rom[5];
            end else begin
                next_y = microcode_rom[4];
                output = output_rom[4];
            end
        end
        3'b011: begin
            if (x) begin
                next_y = microcode_rom[7];
                output = output_rom[7];
            end else begin
                next_y = microcode_rom[6];
                output = output_rom[6];
            end
        end
        3'b100: begin
            if (x) begin
                next_y = microcode_rom[8];
                output = output_rom[8];
            end else begin
                next_y = microcode_rom[8];
                output = output_rom[8];
            end
        end
        default: begin
            next_y = 3'b000;
            output = 2'b00;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
    z <= output[0]; // output
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

MicrocodedFSM microcoded_fsm(
    .clk(clk),
    .reset(reset),
    .x(x),
    .z(z)
);

endmodule