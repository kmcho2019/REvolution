module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] breg;

    // Generate all possible shifted versions of bin
    wire [31:0] shifted_bin [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_bin[i] = {16'b0, breg} << i;
        end
    endgenerate

    // Current shifted value selection
    wire [31:0] current_shift = shifted_bin[count[3:0]];

    // Control signals
    wire counting = (state == BUSY);
    wire add_enable = counting & areg[count[3:0]];
    wire count_done = (count == 5'd16);

    // Output assignments
    assign yout = acc;
    assign done = (state == BUSY) & count_done;

    // Datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 32'b0;
        end else if (add_enable) begin
            acc <= acc + current_shift;
        end else if (start && (state == IDLE)) begin
            acc <= 32'b0;
        end
    end

    // Control FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'b0;
            areg <= 16'b0;
            breg <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= BUSY;
                        areg <= ain;
                        breg <= bin;
                        count <= 5'b0;
                    end
                end
                
                BUSY: begin
                    if (count_done) begin
                        state <= IDLE;
                    end
                    count <= count + 1'b1;
                end
            endcase
        end
    end

endmodule