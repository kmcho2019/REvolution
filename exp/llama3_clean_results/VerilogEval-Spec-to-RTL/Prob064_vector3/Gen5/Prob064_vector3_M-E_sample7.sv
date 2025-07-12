module TopModule #(
    parameter WIDTH = 5,
    parameter NUM_INPUTS = 6,
    parameter NUM_OUTPUTS = 4,
    parameter TOTAL_BITS = NUM_INPUTS * WIDTH + 2
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [WIDTH-1:0] c,
    input  logic [WIDTH-1:0] d,
    input  logic [WIDTH-1:0] e,
    input  logic [WIDTH-1:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [TOTAL_BITS-1:0] serialized_vector;
    logic [WIDTH-1:0] inputs[0:NUM_INPUTS-1];
    logic [7:0] outputs[0:NUM_OUTPUTS-1];
    logic [3:0] state;
    logic [7:0] counter;

    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;
    assign inputs[5] = f;

    assign w = outputs[0];
    assign x = outputs[1];
    assign y = outputs[2];
    assign z = outputs[3];

    always @(posedge state) begin
        case (state)
            4'd0: begin
                // Capture state
                for (int i = 0; i < TOTAL_BITS; i++) begin
                    if (i < WIDTH) begin
                        serialized_vector[i] = inputs[0][WIDTH-1-i];
                    end else if (i < 2*WIDTH) begin
                        serialized_vector[i] = inputs[1][WIDTH-1-(i-WIDTH)];
                    end else if (i < 3*WIDTH) begin
                        serialized_vector[i] = inputs[2][WIDTH-1-(i-2*WIDTH)];
                    end else if (i < 4*WIDTH) begin
                        serialized_vector[i] = inputs[3][WIDTH-1-(i-3*WIDTH)];
                    end else if (i < 5*WIDTH) begin
                        serialized_vector[i] = inputs[4][WIDTH-1-(i-4*WIDTH)];
                    end else if (i < 6*WIDTH) begin
                        serialized_vector[i] = inputs[5][WIDTH-1-(i-5*WIDTH)];
                    end else begin
                        serialized_vector[i] = (i == TOTAL_BITS-1 || i == TOTAL_BITS-2) ? 1'b1 : 1'b0;
                    end
                end
                state = 4'd1;
            end
            4'd1: begin
                // Output state
                for (int i = 0; i < NUM_OUTPUTS; i++) begin
                    for (int j = 0; j < 8; j++) begin
                        if (i*8 + j < TOTAL_BITS) begin
                            outputs[i][7-j] = serialized_vector[i*8 + j];
                        end else begin
                            outputs[i][7-j] = 1'b0;
                        end
                    end
                end
                state = 4'd0;
            end
            default: state = 4'd0;
        endcase
    end

endmodule