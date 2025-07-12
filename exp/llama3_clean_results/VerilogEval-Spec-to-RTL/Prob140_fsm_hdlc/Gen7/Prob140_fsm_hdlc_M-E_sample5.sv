module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Define the states for the top-level FSM
parameter IDLE = 2'b00;
parameter FLAG_DETECT = 2'b01;
parameter ERROR_DETECT = 2'b10;

// Define the signals for the sub-modules
wire [6:0] shift_reg_out;
wire flag_detected;
wire error_detected;
wire disc_detected;

// Instantiate the sub-modules
ShiftRegister shift_reg(
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(shift_reg_out)
);

FlagDetector flag_det(
    .clk(clk),
    .reset(reset),
    .in(shift_reg_out),
    .detected(flag_detected)
);

ErrorDetector error_det(
    .clk(clk),
    .reset(reset),
    .in(shift_reg_out),
    .detected(error_detected)
);

DiscardDetector disc_det(
    .clk(clk),
    .reset(reset),
    .in(shift_reg_out),
    .detected(disc_detected)
);

// Top-level FSM
reg [1:0] state;
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (flag_detected) begin
                    state <= FLAG_DETECT;
                    flag_reg <= 1;
                end else if (error_detected) begin
                    state <= ERROR_DETECT;
                    err_reg <= 1;
                end else if (disc_detected) begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
            end
            FLAG_DETECT: begin
                state <= IDLE;
                flag_reg <= 0;
            end
            ERROR_DETECT: begin
                if (!in) begin
                    state <= IDLE;
                    err_reg <= 0;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule

module ShiftRegister(
    input  clk,
    input  reset,
    input  in,
    output [6:0] out
);

reg [6:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 0;
    end else begin
        shift_reg <= {shift_reg[5:0], in};
    end
end

assign out = shift_reg;

endmodule

module FlagDetector(
    input  clk,
    input  reset,
    input [6:0] in,
    output detected
);

reg detected_reg;

always @(posedge clk) begin
    if (reset) begin
        detected_reg <= 0;
    end else begin
        if (in == 7'b01111110) begin
            detected_reg <= 1;
        end else begin
            detected_reg <= 0;
        end
    end
end

assign detected = detected_reg;

endmodule

module ErrorDetector(
    input  clk,
    input  reset,
    input [6:0] in,
    output detected
);

reg detected_reg;

always @(posedge clk) begin
    if (reset) begin
        detected_reg <= 0;
    end else begin
        if (in == 7'b01111111) begin
            detected_reg <= 1;
        end else begin
            detected_reg <= 0;
        end
    end
end

assign detected = detected_reg;

endmodule

module DiscardDetector(
    input  clk,
    input  reset,
    input [6:0] in,
    output detected
);

reg detected_reg;

always @(posedge clk) begin
    if (reset) begin
        detected_reg <= 0;
    end else begin
        if (in[6:2] == 5'b11111 && !in[1]) begin
            detected_reg <= 1;
        end else begin
            detected_reg <= 0;
        end
    end
end

assign detected = detected_reg;

endmodule