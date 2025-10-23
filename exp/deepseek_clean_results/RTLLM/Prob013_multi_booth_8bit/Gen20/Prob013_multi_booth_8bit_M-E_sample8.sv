module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] counter;
    reg [15:0] mcand;
    reg [8:0] mplier;
    reg [15:0] partial_prod;
    reg [15:0] accum;

    // Pipeline registers
    reg [15:0] mcand_pipe;
    reg [8:0] mplier_pipe;
    reg [15:0] accum_pipe;

    // Booth encoding signals
    wire [3:0] booth_sel;
    wire [15:0] pp0, pp1, pp2, pp3;

    // Booth encoding for all digit positions
    assign booth_sel[0] = mplier[1:0];
    assign booth_sel[1] = mplier[3:1];
    assign booth_sel[2] = mplier[5:3];
    assign booth_sel[3] = mplier[7:5];

    // Partial product generation
    assign pp0 = (booth_sel[0] == 3'b001 || booth_sel[0] == 3'b010) ? mcand :
                (booth_sel[0] == 3'b011) ? (mcand << 1) :
                (booth_sel[0] == 3'b100) ? -(mcand << 1) :
                (booth_sel[0] == 3'b101 || booth_sel[0] == 3'b110) ? -mcand : 16'b0;

    assign pp1 = (booth_sel[1] == 3'b001 || booth_sel[1] == 3'b010) ? (mcand << 2) :
                (booth_sel[1] == 3'b011) ? (mcand << 3) :
                (booth_sel[1] == 3'b100) ? -(mcand << 3) :
                (booth_sel[1] == 3'b101 || booth_sel[1] == 3'b110) ? -(mcand << 2) : 16'b0;

    assign pp2 = (booth_sel[2] == 3'b001 || booth_sel[2] == 3'b010) ? (mcand << 4) :
                (booth_sel[2] == 3'b011) ? (mcand << 5) :
                (booth_sel[2] == 3'b100) ? -(mcand << 5) :
                (booth_sel[2] == 3'b101 || booth_sel[2] == 3'b110) ? -(mcand << 4) : 16'b0;

    assign pp3 = (booth_sel[3] == 3'b001 || booth_sel[3] == 3'b010) ? (mcand << 6) :
                (booth_sel[3] == 3'b011) ? (mcand << 7) :
                (booth_sel[3] == 3'b100) ? -(mcand << 7) :
                (booth_sel[3] == 3'b101 || booth_sel[3] == 3'b110) ? -(mcand << 6) : 16'b0;

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (a != 0 && b != 0) ? COMPUTE : DONE;
            COMPUTE: next_state = (counter == 3'd1) ? DONE : COMPUTE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath - Stage 1 (Booth encoding)
    always @(posedge clk) begin
        if (state == IDLE && next_state == COMPUTE) begin
            mcand <= {{8{a[7]}}, a};
            mplier <= {b, 1'b0};
            accum <= 16'b0;
            counter <= 0;
        end else if (state == COMPUTE) begin
            partial_prod <= pp0 + pp1 + pp2 + pp3;
            mcand_pipe <= mcand << 8;
            mplier_pipe <= mplier >> 8;
            accum_pipe <= accum;
            counter <= counter + 1;
        end
    end

    // Datapath - Stage 2 (Accumulation)
    always @(posedge clk) begin
        if (state == COMPUTE && counter == 1) begin
            p <= accum_pipe + partial_prod;
            rdy <= 1'b1;
        end else if (state == DONE) begin
            rdy <= 1'b0;
        end
    end

endmodule