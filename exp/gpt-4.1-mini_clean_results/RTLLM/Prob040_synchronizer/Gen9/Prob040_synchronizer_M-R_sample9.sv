module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Data and enable registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Synchronizer for enable signal crossing clk_a -> clk_b domain
    wire synced_en;

    // clk_a domain: latch data_in and data_en when data_en is asserted, with async reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else if (data_en) begin
            data_reg    <= data_in;
            en_data_reg <= 1'b1;
        end else begin
            en_data_reg <= 1'b0;
        end
    end

    // Two-stage synchronizer module instantiated here
    synchronizer_sync_2ff en_sync (
        .clk(clk_b),
        .arstn(brstn),
        .async_in(en_data_reg),
        .sync_out(synced_en)
    );

    // Output data logic in clk_b domain
    // Use combinational MUX to decide next output value and then register it
    reg [3:0] next_dataout;
    always @(*) begin
        if (synced_en)
            next_dataout = data_reg;
        else
            next_dataout = dataout;
    end

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= next_dataout;
        end
    end

endmodule


// Two-flip-flop synchronizer module for crossing clk_a to clk_b domain
module synchronizer_sync_2ff (
    input  wire clk,
    input  wire arstn,      // async active-low reset
    input  wire async_in,
    output wire sync_out
);

    reg ff1, ff2;

    always @(posedge clk or negedge arstn) begin
        if (!arstn) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
        end else begin
            ff1 <= async_in;
            ff2 <= ff1;
        end
    end

    assign sync_out = ff2;

endmodule