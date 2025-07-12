module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // -------- clk_a domain --------
    // Register to hold data when data_en asserted
    reg [3:0] data_reg;
    reg       en_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg   <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
                en_reg   <= 1'b1;
            end else begin
                en_reg <= 1'b0;
            end
        end
    end

    // -------- clk_b domain --------
    // Synchronize en_reg (1 bit) from clk_a domain into clk_b domain using 2-stage shift register
    reg en_sync_ff1, en_sync_ff2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_ff1 <= 1'b0;
            en_sync_ff2 <= 1'b0;
        end else begin
            en_sync_ff1 <= en_reg;
            en_sync_ff2 <= en_sync_ff1;
        end
    end

    // Detect rising edge of synchronized enable signal in clk_b domain
    wire en_rising = en_sync_ff1 & (~en_sync_ff2);

    // FSM in clk_b domain to control output update
    typedef enum logic [1:0] {IDLE=2'd0, LOAD=2'd1, HOLD=2'd2} state_t;
    reg [1:0] state, next_state;

    // Capture data_reg sampled asynchronously from clk_a domain on enable rising edge
    reg [3:0] data_capture;

    // FSM sequential logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            state        <= IDLE;
            data_capture <= 4'b0;
            dataout      <= 4'b0;
        end else begin
            state <= next_state;
            // On LOAD state, capture new data
            if (next_state == LOAD) begin
                data_capture <= data_reg;
            end
            // On LOAD or HOLD states, update dataout with captured data
            if (next_state == LOAD || next_state == HOLD) begin
                dataout <= data_capture;
            end
            // On IDLE, keep dataout unchanged
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = en_rising ? LOAD : IDLE;
            LOAD:  next_state = HOLD;
            HOLD:  next_state = en_rising ? LOAD : HOLD;
            default: next_state = IDLE;
        endcase
    end

endmodule